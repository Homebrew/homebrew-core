class Jp < Formula
  desc "Dead simple terminal plots from JSON data"
  homepage "https://github.com/sgreben/jp"
  url "https://github.com/sgreben/jp/archive/1.1.12.tar.gz"
  sha256 "8c9cddf8b9d9bfae72be448218ca0e18d24e755d36c915842b12398fefdc7a64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea0dcfefb673157d2c4492bfa9e2bc012f475e7dfa23e28b6c18ce5805474a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37b85d8d9876ffae1cdf4a3897ca558f2586a826a229d9b85d5799b33e338a89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aa9562dff431b094f70d345de3957b0732ccb1695647575fe34d027d2130938"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab9a9c62daeea0f88e6fbfaa6fccfb630ff4845f9d6fbf587ba4f2d36a015ba"
    sha256 cellar: :any_skip_relocation, monterey:       "bc42ad4f32e4380b871408f010259e4e25f10db71d61d7a739a0e4c12325cef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "821c7e9f81aced60be498ca8820c76c0bc5ae825f1de4d1b1b67a7376e1cff6a"
    sha256 cellar: :any_skip_relocation, catalina:       "ee325c2512d2a069983175999db20d55c8718fd0f0ea000692e6517ac67b32b9"
    sha256 cellar: :any_skip_relocation, mojave:         "53127a663b20c7c0ac893d991330ca862a6eaa8f235586019e1b8ac33159bcf3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "51045489ba9e8790a83a2a366709bd941d3a9e7c190f6c184bcf308b888496b3"
    sha256 cellar: :any_skip_relocation, sierra:         "b75e4ab3a48e2212babba26a4258645ae55eefa50a9ccac463991b05ce4c08d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b35ee0680b137a2202b4ce685bbfa80ccd9dca2ec2e7ab550b2f3384b2b8f68"
  end

  depends_on "go" => :build

  # Fix build on ARM by adding a corresponding Makefile target
  patch :DATA

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    build_root = buildpath/"src/github.com/sgreben/jp"
    build_root.install Dir["*"]
    cd build_root do
      arch = Hardware::CPU.arch.to_s
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      system "make", "binaries/#{os}_#{arch}/jp"
      bin.install "binaries/#{os}_#{arch}/jp"
    end
  end

  test do
    pipe_output("#{bin}/jp -input csv -xy '[*][0,1]'", "0,0\n1,1\n", 0)
  end
end

__END__
diff --git a/Makefile b/Makefile
index adc9d13..664b6af 100644
--- a/Makefile
+++ b/Makefile
@@ -90,3 +90,10 @@ release/$(APP)_$(VERSION)_linux_arm64.zip: binaries/linux_arm64/$(APP)

 binaries/linux_arm64/$(APP): $(GOFILES)
 	GOOS=linux GOARCH=arm64 go build -ldflags "-X main.version=$(VERSION)" -o binaries/linux_arm64/$(APP) ./cmd/$(APP)
+
+release/$(APP)_$(VERSION)_osx_arm64.zip: binaries/osx_arm64/$(APP)
+	mkdir -p release
+	cd ./binaries/osx_arm64 && zip -r -D ../../release/$(APP)_$(VERSION)_osx_arm64.zip $(APP)
+
+binaries/osx_arm64/$(APP): $(GOFILES)
+	GOOS=darwin GOARCH=arm64 go build -ldflags "-X main.version=$(VERSION)" -o binaries/osx_arm64/$(APP) ./cmd/$(APP)
