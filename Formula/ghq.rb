class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.11.0.tar.gz"
  sha256 "3f3c8cd3b6e8a8417d0ef327eedabc42e1ed14d73d31aa9c7cd19323e629db5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ba8e1760aec6d26656bf8095bef406402deef7bb5a24cbb1fb83e964dfe918b" => :mojave
    sha256 "87153ca174bb512217c7e032390facca3362c503e4bb895089501ef63aa1925d" => :high_sierra
    sha256 "e9e32a04d5064a9e172e636ccd647e9dc2c4a6b8f992922bb5f93eaa0f47427d" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
