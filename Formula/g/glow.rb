class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "b4ecf269b7c6447e19591b1d23f398ef2b38a6a75be68458390b42d3efc44b92"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4486241aaf23f7ebb97e03b0a8adbb989024dff5fbb4ab1c99c223d6ff262e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59753a888910c13add586fc3de3abbb157813818b6aebabc2c43bfc34b4b8184"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f441f6021458b282da2ccdfb720826ed604f7f8dbf2849540a39397281cbb95"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7be74a04e794af12071f494b9e2ee896f3e5f21707ac9c1859a9e32591a40e7"
    sha256 cellar: :any_skip_relocation, ventura:        "3865595d8a6d7054675868edfe7decec77b208a79ed74e5af690a6f995324351"
    sha256 cellar: :any_skip_relocation, monterey:       "12f8ce65f74a79ece88015233caf2fc95ec5b0fd630606e0f422da3be306bf01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f47e194373a7a04485809904de89acca935fd9116cbcb807c7c5245f9478bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"glow", "completion")
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS

    # failed with Linux CI run, but works with local run
    # https://github.com/charmbracelet/glow/issues/454
    if OS.linux?
      system bin/"glow", test_file
    else
      assert_match "# header", shell_output("#{bin}/glow #{test_file}")
    end
  end
end
