class Ioke < Formula
  desc "Dynamic language targeted at virtual machines"
  homepage "https://ioke.org/"
  url "https://ioke.org/dist/ioke-P-ikj-0.4.0.tar.gz"
  sha256 "701d24d8a8d0901cde64f11c79605c21d43cafbfb2bdd86765b664df13daec7c"

  livecheck do
    url "https://ioke.org/download.html"
    regex(/href=.*?ioke-P-ikj[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f78a97e3add6cfc850a4e26c1adc46214b8ac9918a27ccc846b25d433f6b8ac0"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Point IOKE_HOME to libexec
    inreplace libexec/"bin/ioke" do |s|
      s.change_make_var! "IOKE_HOME", libexec
    end

    (bin/"ioke").write_env_script libexec/"bin/ioke", Language::Java.overridable_java_home_env
    bin.install_symlink libexec/"bin/ispec",
                        libexec/"bin/dokgen"
  end

  test do
    system "#{bin}/ioke", "-e", '"test" println'
  end
end
