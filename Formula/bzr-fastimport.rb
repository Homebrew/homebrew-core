class BzrFastimport < Formula
  desc "Bazaar plugin for fast loading of revision control"
  homepage "https://launchpad.net/bzr-fastimport"
  url "https://launchpad.net/bzr-fastimport/trunk/0.13.0/+download/bzr-fastimport-0.13.0.tar.gz"
  sha256 "5e296dc4ff8e9bf1b6447e81fef41e1217656b43368ee4056a1f024221e009eb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b8d7ead1690a67dc56050009a5e599765c6219ca236fa4035d979686a3a14c5b" => :catalina
    sha256 "adb80d5f3694b382190564db1bf0f402dc4a63e5fc769846e79e61f258ff14ac" => :mojave
    sha256 "af2955ee5a026c4573dbeb4be897babf2f8d3805636765b982b48793b8143c60" => :high_sierra
    sha256 "420a665897be0a5e807a396720e51cb722b8ead02effee281d5843d56e3881be" => :sierra
    sha256 "119240e135fcf0d170a009bd414b07fe13f65734afd5929de2527a62c66b6c79" => :el_capitan
    sha256 "1155531ccdff247dcf8ab9cae133263199cbd708a1ae6ddc4d6e68133d1ab712" => :yosemite
    sha256 "d784f0b66db2e31f53f7b21fa5263c3d050b490a45684d0f206c9488ca0335a6" => :mavericks
  end

  depends_on "bazaar"
  depends_on "python@2" # does not support Python 3

  resource "python-fastimport" do
    url "https://launchpad.net/python-fastimport/trunk/0.9.2/+download/python-fastimport-0.9.2.tar.gz"
    sha256 "fd60f1173e64a5da7c5d783f17402f795721b7548ea3a75e29c39d89a60f261e"
  end

  def install
    resource("python-fastimport").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    (share/"bazaar/plugins/fastimport").install Dir["*"]
  end

  def caveats; <<~EOS
    In order to use this plugin you must set your PYTHONPATH in your #{shell_profile}:

      export PYTHONPATH="#{opt_libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    bzr = Formula["bazaar"].bin/"bzr"
    system bzr, "init"
    assert_match(/fastimport #{version}/,
                 shell_output("#{bzr} plugins --verbose"))
    system bzr, "fast-export", "--plain", "."
  end
end
