class Gokart < Formula
  desc "Static code analysis for securing Go code"
  homepage "https://github.com/praetorian-inc/gokart"
  url "https://github.com/praetorian-inc/gokart/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ac73f90d274851ac00e2f3fb269a493ea9b4c06eb8d6d1db0ae953bf85129ad6"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/gokart.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca65ab68b72d0bbd7c054bdf86fe30338c1cd479f8eb4c11c2c118d3dac2483f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "146157bf16be2215dc0596459fd413a8d52a6179f4c5424f30af8362042cf999"
    sha256 cellar: :any_skip_relocation, monterey:       "af854ceaf46f62cf2097f4b4f1959e434b8975848bb6d034242f4fa21ec7727d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b3ae2bf1fb83d1bc71952fc6da682c05b8da59134907f6e7386327f076d74e9"
    sha256 cellar: :any_skip_relocation, catalina:       "c17b7de4bd2a3c6741d99cb395ee7ab9536977d14ba6881c7128a796255d87a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b48d4fc955daaa16a88e57f71a561f7f35458739aac7c54186558e355bb8ab4d"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS
    end

    assert_match "GoKart found 0 potentially vulnerable functions",
      shell_output("#{bin}/gokart scan brewtest")

    assert_match version.to_s, shell_output("#{bin}/gokart version")
  end
end
