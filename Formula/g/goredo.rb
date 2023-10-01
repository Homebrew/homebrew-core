class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.32.0.tar.zst"
  sha256 "4e557533976f25fe9964e7974f553a4e477dc239d73072c68ec2e46c90d76e52"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9633947412018c60630bebe629eb4f60b6366bc292b3f145e9ba7f6807fcd801"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9633947412018c60630bebe629eb4f60b6366bc292b3f145e9ba7f6807fcd801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9633947412018c60630bebe629eb4f60b6366bc292b3f145e9ba7f6807fcd801"
    sha256 cellar: :any_skip_relocation, sonoma:         "08a5cf93223b6ed306cb6aea73c0a4bac63cdb2277ac5f739b5ca7fc86362d9a"
    sha256 cellar: :any_skip_relocation, ventura:        "08a5cf93223b6ed306cb6aea73c0a4bac63cdb2277ac5f739b5ca7fc86362d9a"
    sha256 cellar: :any_skip_relocation, monterey:       "08a5cf93223b6ed306cb6aea73c0a4bac63cdb2277ac5f739b5ca7fc86362d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e53611ca42dfc43d38cb31e8280965b25cc920ee5e44572314e6f80561d1ae"
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
