class Livestreamer < Formula
  desc "Pipes video from streaming services into a player such as VLC"
  homepage "https://livestreamer.io/"
  url "https://files.pythonhosted.org/packages/ee/d6/efbe3456160a2c62e3dd841c5d9504d071c94449a819148bb038b50d862a/livestreamer-1.12.2.tar.gz"
  sha256 "ef3e743d0cabc27d8ad906c356e74370799e25ba46c94d3b8d585af77a258de0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5d261e64d0bd86160b44dd62d3a93d2ef7c1ac28a01c4db04e026be389f13809" => :mojave
    sha256 "c6517deb167fe5b05bc120c260487b0676de4e0f3a05cf8ed771bfb5cf2e67cc" => :high_sierra
    sha256 "9200989d249443fc8daa7827d8490df5b9a056d2df9182fd6a10d8eab1893b69" => :sierra
  end

  depends_on "python"

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/11/3f/2b3c217c5427cdd12619024b1ee1b04d49e27fde5c29df2a0b92c26677c2/six-1.8.0.tar.gz"
    sha256 "047bbbba41bac37c444c75ddfdf0573dd6e2f1fbd824e6247bb26fa7d8fa3830"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/livestreamer --version 2>&1")
  end
end
