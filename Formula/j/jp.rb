class Jp < Formula
  desc "Dead simple terminal plots from JSON data"
  homepage "https://github.com/sgreben/jp"
  url "https://github.com/sgreben/jp/archive/refs/tags/1.1.12.tar.gz"
  sha256 "8c9cddf8b9d9bfae72be448218ca0e18d24e755d36c915842b12398fefdc7a64"
  license "MIT"
  head "https://github.com/sgreben/jp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d7cea97678a221ad8241eb0c56c01fcb9b21d79e7da603735a09f60bf3bd9789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "01da1efbfd32691e7a34fa8e13108bfd327d52cc9b76a349a900df7f3a6411c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f3a46aca24fd10a6f170d25b5f59ec1247a393f0aa71fa2e6d7d0994f4e3631"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea0dcfefb673157d2c4492bfa9e2bc012f475e7dfa23e28b6c18ce5805474a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37b85d8d9876ffae1cdf4a3897ca558f2586a826a229d9b85d5799b33e338a89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aa9562dff431b094f70d345de3957b0732ccb1695647575fe34d027d2130938"
    sha256 cellar: :any_skip_relocation, sonoma:         "eabebf5cde6cd8194096698286fb9170e265dd0acab15cce4e5ebca0815a7aa3"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab9a9c62daeea0f88e6fbfaa6fccfb630ff4845f9d6fbf587ba4f2d36a015ba"
    sha256 cellar: :any_skip_relocation, monterey:       "bc42ad4f32e4380b871408f010259e4e25f10db71d61d7a739a0e4c12325cef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "821c7e9f81aced60be498ca8820c76c0bc5ae825f1de4d1b1b67a7376e1cff6a"
    sha256 cellar: :any_skip_relocation, catalina:       "ee325c2512d2a069983175999db20d55c8718fd0f0ea000692e6517ac67b32b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "475d898241d31bf3a521ebd1dceec1c13d9772fe049d60bab9efab3bd450f7ea"
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
