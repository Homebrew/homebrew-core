class Labctl < Formula
    desc "CLI tool for interacting with iximiuz labs and playgrounds"
    homepage "https://github.com/iximiuz/labctl"
    url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.50.tar.gz"
    sha256 "38373d00cc5fb0bec1f9332dcf7c21e320441be294b02f630ff1dff9d04c9d08"
    license "MIT"
  
    depends_on "go" => :build
  
    def install
      system "go", "build", *std_go_args
    end
  
    test do
      assert_match "labctl", shell_output("#{bin}/labctl --help")
    end
  end