class Hyperbolic < Formula
    desc "Command-line interface for creating and managing GPU instances on Hyperbolic"
    homepage "https://github.com/HyperbolicLabs/hyperbolic-cli"
    url "https://github.com/HyperbolicLabs/hyperbolic-cli/archive/refs/tags/v0.0.2.tar.gz"
    sha256 "e518fe7843b627dec73cfa31c7c1b0e7dfff0d7b1054f9abef10ed27b0e5715d"
    license "MIT"
    head "https://github.com/HyperbolicLabs/hyperbolic-cli.git", branch: "main"
  
    depends_on "go" => :build
  
    def install
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"hyperbolic")
    end
  
    test do
      assert_match "hyperbolic", shell_output("#{bin}/hyperbolic --help")
      
      assert_predicate bin/"hyperbolic", :exist?
      assert_predicate bin/"hyperbolic", :executable?
    end
  end 