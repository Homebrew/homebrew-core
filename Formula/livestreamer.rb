class Livestreamer < Formula
  desc "Pipes video from streaming services into a player such as VLC"
  homepage "https://livestreamer.io/"
  url "https://files.pythonhosted.org/packages/ee/d6/efbe3456160a2c62e3dd841c5d9504d071c94449a819148bb038b50d862a/livestreamer-1.12.2.tar.gz"
  sha256 "ef3e743d0cabc27d8ad906c356e74370799e25ba46c94d3b8d585af77a258de0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "aa557de649a9254587074399bc5e81a848dca4d28498550e63cd5126b6cec817" => :mojave
    sha256 "84d580d9c9de044903fab8326349a0b3beb928a953c087de4ab9d94f76eab445" => :high_sierra
    sha256 "4830984511ba774a7047417ce2c304a79ef6c9c95170ef628f754300e081eab9" => :sierra
    sha256 "08751c90099fb817e5adb721dae3cb1e11852e975c731909baff4001bae4da2c" => :el_capitan
    sha256 "4f3e898e82718fb8c6fe9597cd0e7289388283c30cedd8c78d699989a0805977" => :yosemite
    sha256 "b91f4e0f5a293dbb12134bc5be6b2d4ec7c80e309fca8d4901376e15c8b5df87" => :mavericks
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
