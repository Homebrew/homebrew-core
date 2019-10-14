class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/fc/ab/b51afd466cc4acf2192e230ddb6fd3adb56066f05c7be1852af7bd655068/ccm-3.1.4.tar.gz"
  sha256 "a98268c2d8e5534d8d2d94267060e9ee9105b35e43d704bac0fa495a773acf7d"
  revision 1
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3627c714efdd2229e82ee9fa5b0c26f0c2144b6f2644f316aaa55ed0987798c4" => :catalina
    sha256 "7459ea7995ce0dfe7289e55b0d4b78dca3a41909b2a067c908226da64df67051" => :mojave
    sha256 "00bf2f352fc8ea1d34560c269db3d8674f7aacf73a691a26a959d3073127473c" => :high_sierra
    sha256 "4888764eb18e9bb810507cce436275d9af23d81ed52d26b168ba23fd1d40c9a7" => :sierra
  end

  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/2d/77/2e344b58ffe8b11271735c1ee88fa668c897c5b72ed1913067dd86e1a966/cassandra-driver-3.13.0.tar.gz"
    sha256 "61b670fb2ba95d51d91fa7b589aae3666df494713f5d1ed78bb5c510778d77f0"
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
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
