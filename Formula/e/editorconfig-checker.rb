class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "8c8e6662b076fdb21767e0df99b12b71cbcde5cfbbd8a084b4cf94fe09b72826"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c3943c8c379e3ed6edbaaf7ff729bbead0ce913291ca9096d7f27c35bc6c9d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c3943c8c379e3ed6edbaaf7ff729bbead0ce913291ca9096d7f27c35bc6c9d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c3943c8c379e3ed6edbaaf7ff729bbead0ce913291ca9096d7f27c35bc6c9d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c44690c2c2877d318e4159e0789d2c2ee26f8e7a63585b538abc57e2bb9b56d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37c5ce8d2cfbb5514eb05cf4c9f83bd6fda82e6e5b6936112596446e704a19c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ec5262b1ab9d209a5bd9b0cb9f5740cfd99e30009e2aaf25f0ee8180512964"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/".editorconfig").write <<~EOS
      [version.txt]
      charset = utf-8
    EOS
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
