class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.29.0.tar.zst"
  sha256 "cc8d5c0c2df9e868037ac47d30a2f9aa275d8945a5f1ee5106344de30181d053"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "458e97faccdf2f6c46970ce24b281e444036b27b7a322263e2f52a71972a7ba4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "458e97faccdf2f6c46970ce24b281e444036b27b7a322263e2f52a71972a7ba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "458e97faccdf2f6c46970ce24b281e444036b27b7a322263e2f52a71972a7ba4"
    sha256 cellar: :any_skip_relocation, ventura:        "c42f642bf6c4c4b9c7953cc8139372fa0b2b18c09f79d7fd980dee5edf720d22"
    sha256 cellar: :any_skip_relocation, monterey:       "c42f642bf6c4c4b9c7953cc8139372fa0b2b18c09f79d7fd980dee5edf720d22"
    sha256 cellar: :any_skip_relocation, big_sur:        "c42f642bf6c4c4b9c7953cc8139372fa0b2b18c09f79d7fd980dee5edf720d22"
    sha256 cellar: :any_skip_relocation, catalina:       "c42f642bf6c4c4b9c7953cc8139372fa0b2b18c09f79d7fd980dee5edf720d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b1fdb925e45a88b857ddbd1e7e5a7c018e0176e4e101d03a9d4d7140c62f06c"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
