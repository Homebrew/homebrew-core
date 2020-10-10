class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v4.3.1.tar.gz"
  sha256 "f756182ed383050cbdaac8ee4f02c904ca26f76a727f3ec58cc8ab6a8cba3f23"
  license "GPL-3.0"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab7dc8c32567630c5eb8348dd980024a0e627c39770f465f8f4bc5b7f2333d2f" => :catalina
    sha256 "2dbb353381599066e977437e053a751f0ee7d09de78c1837040d1eb38f29ed33" => :mojave
    sha256 "adb6f377a2dc1af03609a799edb3c94b81602c179f76ed0ea1837a37a17a25c9" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "googler"
    system "make", "disable-self-upgrade"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
