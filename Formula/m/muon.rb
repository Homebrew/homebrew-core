class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.2.0.tar.gz"
  sha256 "d73db1be5388821179a25a15ba76fd59a8bf7c8709347a4ec2cb91755203f36c"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8f93def427f4c722d5408c1a8b25c356f166426c3ab4bb8902e7c1e1698c788"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18b3d76e8b2ebb078b87ce9c442168e9543df14e014442dc239554b83d633c91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6327c8aa41fbbd6ba927a03d093f2f09f66e8a26b69e369add305e4179d5e3ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9506eb66834d26363c3de7b52dc930c8c80d821ec54aa2a76ea9c850d9eb7fae"
    sha256 cellar: :any_skip_relocation, sonoma:         "70f39de6ed30f8deacadffece7fa1c1b4b94c12c8a8223635a92b901e47a571c"
    sha256 cellar: :any_skip_relocation, ventura:        "fb33b7d82f66af0010f5a47db3a90a9f7bc5bd195dc8a11b80f01ad22ce76909"
    sha256 cellar: :any_skip_relocation, monterey:       "e3f056c2235a9bd35602454cc0a696b342a6324b18a90195ad5c2390de5134c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0ace57d38a0d5156f80359e08e688facfafd5ba487146013480a58bfb32385f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ccf7ccaf0a8b108319e15a8e0a172db4d7561009f3519f205ac34e4151da50e"
  end

  depends_on "ninja"
  depends_on "pkg-config"

  def install
    system "./bootstrap.sh", "build"
    system "./build/muon", "setup", "-Dprefix=#{prefix}", "build"
    system "ninja", "-C", "build"
    system "./build/muon", "-C", "build", "install"
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    system bin/"muon", "setup", "build"
    assert_predicate testpath/"build/build.ninja", :exist?

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
