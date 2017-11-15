class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/3.9.0/commandbox-bin-3.9.0.zip"
  sha256 "9497a7db8879150548b05d28594cc7d316556fc3a2e4602d3795b589ba85105e"

  bottle :unneeded

  depends_on :java => "1.8"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/3.9.0/commandbox-apidocs-3.9.0.zip"
    sha256 "ffdbc521837f963d73295bf2ed8ecf55edfb20aa817ea95da89fc375a575f23c"
  end

  def install
    libexec.install "box"
    (bin/"box").write_env_script libexec/"box", Language::Java.java_home_env("1.8")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
