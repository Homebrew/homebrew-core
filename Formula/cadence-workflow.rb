class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
    tag:      "v0.20.0",
    revision: "175850a28469c79c3ec43da7832d5a997c079667"
  license "MIT"
  head "https://github.com/uber/cadence.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4108b02d4a11dba98b26af83c2633550d922eeb00160218458f9896244cc6b25"
    sha256 cellar: :any_skip_relocation, big_sur:       "04a9302cdc9bd7ac3986ba5dba8d786dda09737410071b5d33d59645369bb0fe"
    sha256 cellar: :any_skip_relocation, catalina:      "2402f801a03a4d4a5a557958e0f7342e70901c988475eaed26ac02e1f9e84fa8"
    sha256 cellar: :any_skip_relocation, mojave:        "5f123ab1904790aa0442ad18d3f9fc09ee99799711403e96e613964c3ad84ac3"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  # build patch, remove in next release
  # ref commit, https://github.com/uber/cadence/commit/b6b70ffbced027f0833696aea09be350bd41d15e
  patch :DATA

  def install
    system "make", "cadence", "cadence-server", "cadence-canary", "cadence-sql-tool", "cadence-cassandra-tool"
    bin.install "cadence"
    bin.install "cadence-server"
    bin.install "cadence-canary"
    bin.install "cadence-sql-tool"
    bin.install "cadence-cassandra-tool"

    (etc/"cadence").install "config", "schema"
  end

  test do
    output = shell_output("#{bin}/cadence-server start 2>&1", 1)
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end

__END__
diff --git a/Makefile b/Makefile
index 55f32cb..437c34b 100644
--- a/Makefile
+++ b/Makefile
@@ -128,8 +128,8 @@ $(BIN)/goimports: go.mod
 $(BIN)/revive: go.mod
 	$(call go_build_tool,github.com/mgechev/revive)

-$(BIN)/protoc-gen-gofast: go.mod | $(BIN)
-	$(call go_build_tool,github.com/gogo/protobuf/protoc-gen-gofast)
+$(BIN)/protoc-gen-gogofast: go.mod | $(BIN)
+	$(call go_build_tool,github.com/gogo/protobuf/protoc-gen-gogofast)

 $(BIN)/protoc-gen-yarpc-go: go.mod | $(BIN)
 	$(call go_build_tool,go.uber.org/yarpc/encoding/protobuf/protoc-gen-yarpc-go)
@@ -156,7 +156,7 @@ $(BIN)/$(BUF_VERSION_BIN): | $(BIN)
 	@chmod +x $@

 # https://www.grpc.io/docs/languages/go/quickstart/
-# protoc-gen-gofast (yarpc) are versioned via tools.go + go.mod (built above) and will be rebuilt as needed.
+# protoc-gen-gogofast (yarpc) are versioned via tools.go + go.mod (built above) and will be rebuilt as needed.
 # changing PROTOC_VERSION will automatically download and use the specified version
 PROTOC_VERSION = 3.14.0
 PROTOC_URL = https://github.com/protocolbuffers/protobuf/releases/download/v$(PROTOC_VERSION)/protoc-$(PROTOC_VERSION)-$(subst Darwin,osx,$(OS))-$(ARCH).zip
@@ -166,7 +166,7 @@ PROTOC_UNZIP_DIR = $(BIN)/protoc-$(PROTOC_VERSION)-zip
 # otherwise this must be a .PHONY rule, or the buf bin / symlink could become out of date.
 PROTOC_VERSION_BIN = protoc-$(PROTOC_VERSION)
 $(BIN)/$(PROTOC_VERSION_BIN): | $(BIN)
-	@echo "downloading protoc $(PROTOC_VERSION)"
+	@echo "downloading protoc $(PROTOC_VERSION): $(PROTOC_URL)"
 	@# recover from partial success
 	@rm -rf $(BIN)/protoc.zip $(PROTOC_UNZIP_DIR)
 	@# download, unzip, copy to a normal location
@@ -178,6 +178,15 @@ $(BIN)/$(PROTOC_VERSION_BIN): | $(BIN)
 # Codegen targets
 # ====================================

+# IDL submodule must be populated, or files will not exist -> prerequisites will be wrong -> build will fail.
+# Because it must exist before the makefile is parsed, this cannot be done automatically as part of a build.
+# Instead: call this func in targets that require the submodule to exist, so that target will not be built.
+#
+# THRIFT_FILES is just an easy identifier for "the submodule has files", others would work fine as well.
+define ensure_idl_submodule
+$(if $(THRIFT_FILES),,$(error idls/ submodule must exist, or build will fail.  Run `git submodule update --init` and try again))
+endef
+
 # codegen is done when thrift and protoc are done
 $(BUILD)/codegen: $(BUILD)/thrift $(BUILD)/protoc | $(BUILD)
 	@touch $@
@@ -190,6 +199,7 @@ THRIFT_GEN := $(subst idls/thrift/,.build/,$(THRIFT_FILES))

 # thrift is done when all sub-thrifts are done
 $(BUILD)/thrift: $(THRIFT_GEN) | $(BUILD)
+	$(call ensure_idl_submodule)
 	@touch $@

 # how to generate each thrift book-keeping file.
@@ -209,23 +219,24 @@ $(THRIFT_GEN): $(THRIFT_FILES) $(BIN)/thriftrw $(BIN)/thriftrw-plugin-yarpc | $(
 PROTO_ROOT := proto
 # output location is defined by `option go_package` in the proto files, all must stay in sync with this
 PROTO_OUT := .gen/proto
-PROTO_FILES = $(shell find ./$(PROTO_ROOT) -name "*.proto" | grep -v "persistenceblobs")
+PROTO_FILES = $(shell find -L ./$(PROTO_ROOT) -name "*.proto" | grep -v "persistenceblobs")
 PROTO_DIRS = $(sort $(dir $(PROTO_FILES)))

-# protoc splits proto files into directories, otherwise protoc-gen-gofast is complaining about inconsistent package
+# protoc splits proto files into directories, otherwise protoc-gen-gogofast is complaining about inconsistent package
 # import paths due to multiple packages being compiled at once.
 #
 # After compilation files are moved to final location, as plugins adds additional path based on proto package.
-$(BUILD)/protoc: $(PROTO_FILES) $(BIN)/$(PROTOC_VERSION_BIN) $(BIN)/protoc-gen-gofast $(BIN)/protoc-gen-yarpc-go | $(BUILD)
+$(BUILD)/protoc: $(PROTO_FILES) $(BIN)/$(PROTOC_VERSION_BIN) $(BIN)/protoc-gen-gogofast $(BIN)/protoc-gen-yarpc-go | $(BUILD)
+	$(call ensure_idl_submodule)
 	@mkdir -p $(PROTO_OUT)
 	@echo "protoc..."
 	@$(foreach PROTO_DIR,$(PROTO_DIRS),$(BIN)/$(PROTOC_VERSION_BIN) \
-		--plugin $(BIN)/protoc-gen-gofast \
+		--plugin $(BIN)/protoc-gen-gogofast \
 		--plugin $(BIN)/protoc-gen-yarpc-go \
 		-I=$(PROTO_ROOT)/public \
 		-I=$(PROTO_ROOT)/internal \
 		-I=$(PROTOC_UNZIP_DIR)/include \
-		--gofast_out=Mgoogle/protobuf/duration.proto=github.com/gogo/protobuf/types,Mgoogle/protobuf/field_mask.proto=github.com/gogo/protobuf/types,Mgoogle/protobuf/timestamp.proto=github.com/gogo/protobuf/types,Mgoogle/protobuf/wrappers.proto=github.com/gogo/protobuf/types,paths=source_relative:$(PROTO_OUT) \
+		--gogofast_out=Mgoogle/protobuf/duration.proto=github.com/gogo/protobuf/types,Mgoogle/protobuf/field_mask.proto=github.com/gogo/protobuf/types,Mgoogle/protobuf/timestamp.proto=github.com/gogo/protobuf/types,Mgoogle/protobuf/wrappers.proto=github.com/gogo/protobuf/types,paths=source_relative:$(PROTO_OUT) \
 		--yarpc-go_out=$(PROTO_OUT) \
 		$$(find $(PROTO_DIR) -name '*.proto');\
 	)
@@ -243,16 +254,22 @@ $(BUILD)/protoc: $(PROTO_FILES) $(BIN)/$(PROTOC_VERSION_BIN) $(BIN)/protoc-gen-g
 # this will ensure that committed code will be used rather than re-generating.
 # must be manually run before (nearly) any other targets.
 .fake-codegen: .fake-protoc .fake-thrift
+	$(warning build-tool binaries have been faked, you will need to delete the $(BIN) folder if you wish to build real ones)
+	@# touch a marker-file for a `make clean` warning.  this does not impact behavior.
+	touch $(BIN)/fake-codegen

 # "build" fake binaries, and touch the book-keeping files, so Make thinks codegen has been run.
 # order matters, as e.g. a $(BIN) newer than a $(BUILD) implies Make should run the $(BIN).
 .fake-protoc: | $(BIN) $(BUILD)
-	touch $(BIN)/$(PROTOC_VERSION_BIN) $(BIN)/protoc-gen-gofast $(BIN)/protoc-gen-yarpc-go
+	touch $(BIN)/$(PROTOC_VERSION_BIN) $(BIN)/protoc-gen-gogofast $(BIN)/protoc-gen-yarpc-go
 	touch $(BUILD)/protoc

 .fake-thrift: | $(BIN) $(BUILD)
 	touch $(BIN)/thriftrw $(BIN)/thriftrw-plugin-yarpc
-	touch $(THRIFT_GEN)
+	@# if the submodule exists, touch thrift_gen markers to fake their generation.
+	@# if it does not, do nothing - there are none.
+	$(if $(THRIFT_GEN),touch $(THRIFT_GEN),)
+	touch $(BUILD)/thrift

 # ====================================
 # other intermediates
@@ -385,7 +402,9 @@ release: ## Re-generate generated code and run tests
 clean: ## Clean binaries and build folder
 	rm -f $(BINS)
 	rm -Rf $(BUILD)
-	@echo '# rm -rf $(BIN) # not removing tools dir, it is rarely necessary'
+	$(if \
+		$(filter $(BIN)/fake-codegen, $(wildcard $(BIN)/*)), \
+		$(warning fake build tools may exist, delete the $(BIN) folder to get real ones if desired),)

 # v----- not yet cleaned up -----v
