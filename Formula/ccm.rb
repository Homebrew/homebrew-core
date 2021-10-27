class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/pcmanus/ccm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a63a013f478786c34eac1bc519ee9466ccf7c146446e06c993fe0435588947e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d54c130a02a2a8e18fa4ab6581fb247801cb8e4a34ed64556092445a7d00768"
    sha256 cellar: :any_skip_relocation, monterey:       "18ee12aedd0f0d05fb7d61451ba98e981d71e5c8c375450bde94a0eb7c612ca8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5be6d025aa61b10990e45c4158cea86bd6722e5aeb677c5a10e3cadc68971bdf"
    sha256 cellar: :any_skip_relocation, catalina:       "cb07fbe35e0dcea161491e1a670f7605e21b13299c28de8d3ed08102a0d641a4"
    sha256 cellar: :any_skip_relocation, mojave:         "076976be7d2278de9591750dcfada9d9856cb217f2869c9e00ddf459e173e933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f5c11e27bc7042f66c6ed9c5c9d71b98e2c9796be0acdef7ef1012b98c96fa"
  end

  depends_on "python@3.10"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/19/bd/b522b200e8a7cc5ace859e9667308a3a302a23d6df09ae087ca2dfbf60c2/cassandra-driver-3.22.0.tar.gz"
    sha256 "df825ee4ebb7f7fa33ab028d673530184fe0ee41ea66b2f9ddd478db56145a31"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[PyYAML six cassandra-driver].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
