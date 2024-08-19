class Pkger < Formula
  desc "Embed static files in Go binaries (replacement for gobuffalo/packr)"
  homepage "https://github.com/markbates/pkger"
  url "https://github.com/markbates/pkger/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "da775b5ec5675f0db75cf295ff07a4a034ba15eb5cc02d278a5767f387fb8273"
  license "MIT"
  head "https://github.com/markbates/pkger.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82456f62e7fdf97b752398c03a4a61fba2937f421a7c0ad13b85ecc29cdb39ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b43b48fb6c73aa290b35b26c0ef6a8b5faac724e458f1ea8f1aab3d7ce3a7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58e02ef3288e931192f1a27878127f6a7613813af069fd2c8ca6f677d6b6850"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aedbd40a005d310bdf05626cc7946a11d22365bb961465fe70bd54c70fe3f5ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "a336d4bb18f0e0fe3b0283b1fe2ccdc3e100e826ded80638ca4551afc363b0f0"
    sha256 cellar: :any_skip_relocation, ventura:        "fae59c7ef5c213208b2c4216bd6501b3c14122c54d21f7954e0e5eaf352f3bdc"
    sha256 cellar: :any_skip_relocation, monterey:       "c04550bc542979f27dfdaadfb39e60da0e84b364bc818358445b7e15b9443b16"
    sha256 cellar: :any_skip_relocation, big_sur:        "24892dfd92d3a8b7fd4a0840d2bd721e6d7b09954732dd53e50a2c92cea69d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ce72df189628d20fd0f55a3014d23c23882b603102836ae22852cc0778f6a8"
  end

  disable! date: "2023-10-18", because: :repo_archived

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/pkger"
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin/"pkger"
      assert_predicate testpath/"test/pkged.go", :exist?
      assert_equal "{\n \".\": null\n}\n", shell_output("#{bin}/pkger parse")
    end
  end
end
