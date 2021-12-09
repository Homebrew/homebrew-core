class JoobyBootstrap < Formula
  desc "Script to simplify the creation of jooby apps"
  homepage "https://github.com/jooby-project/jooby-bootstrap"
  url "https://github.com/jooby-project/jooby-bootstrap/archive/0.2.2.tar.gz"
  sha256 "ba662dcbe9022205cdb147a1c4e0931191eb902477ca40f3cba0170dfad54fda"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ca58a519ffa11530ab152b7a007c4b11e7bf76767b9296b84626e0516598c7b"
  end

  deprecate! date: "2020-11-13", because: :unmaintained

  depends_on "maven"
  depends_on "openjdk@8"

  def install
    libexec.install "jooby"
    (bin/"jooby").write_env_script libexec/"jooby", Language::Java.java_home_env("1.8")
  end

  test do
    system "#{bin}/jooby", "version"
  end
end
