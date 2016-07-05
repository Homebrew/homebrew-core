class Livestreamer < Formula
  desc "pipes video from streaming services into a player such as VLC"
  homepage "http://livestreamer.io/"
  url "https://files.pythonhosted.org/packages/ee/d6/efbe3456160a2c62e3dd841c5d9504d071c94449a819148bb038b50d862a/livestreamer-1.12.2.tar.gz"
  sha256 "ef3e743d0cabc27d8ad906c356e74370799e25ba46c94d3b8d585af77a258de0"

  bottle do
    cellar :any_skip_relocation
    sha256 "08751c90099fb817e5adb721dae3cb1e11852e975c731909baff4001bae4da2c" => :el_capitan
    sha256 "4f3e898e82718fb8c6fe9597cd0e7289388283c30cedd8c78d699989a0805977" => :yosemite
    sha256 "b91f4e0f5a293dbb12134bc5be6b2d4ec7c80e309fca8d4901376e15c8b5df87" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "futures" do
    url "https://files.pythonhosted.org/packages/c0/12/927b89a24dcb336e5af18a8fbf581581c36e9620ae963a693a2522b2d340/futures-2.2.0.tar.gz"
    sha256 "151c057173474a3a40f897165951c0e33ad04f37de65b6de547ddef107fd0ed3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/11/3f/2b3c217c5427cdd12619024b1ee1b04d49e27fde5c29df2a0b92c26677c2/six-1.8.0.tar.gz"
    sha256 "047bbbba41bac37c444c75ddfdf0573dd6e2f1fbd824e6247bb26fa7d8fa3830"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[futures requests singledispatch six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/livestreamer --version 2>&1")
  end
end
