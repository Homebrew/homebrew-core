class PreCommit < Formula
  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.4.1.tar.gz"
  sha256 "cc908bc0ca5f77cdb6d05d090f9b09a18514de8c82dfea3b8edffda06871f0e6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f7556ecdd7565a5e087b440903b2f275e1afe584043285f170570af54e643a1b" => :high_sierra
    sha256 "e5b75820d000ddb6a52e27be6086bff48bf6464f518cd342403ad5a6a323d325" => :sierra
    sha256 "0ee9a8a386ef6b87fc348eeb9995479ee412a29b841ce778b773b86ed5656899" => :el_capitan
  end

  depends_on :python3

  resource "aspy.yaml" do
    url "https://files.pythonhosted.org/packages/71/bb/3a38181c4ecab92f19d94f6af9e3fa9f9a6284a9008e0b76e555e5520934/aspy.yaml-1.0.0.tar.gz"
    sha256 "6215f44900ff65f27dbd00a36b06a7926276436ed377320cfd4febd69bbd4a94"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/06/2c/ad2baf15231a215c7be0324bdebd3175c320e60eba4cf347560d5749c5b8/cached-property-1.3.1.tar.gz"
    sha256 "6562f0be134957547421dda11640e8cadfa7c23238fc4e0821ab69efdb1095f3"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/99/48/abbd92112320a8e09f23a05adf1a6ebc6d50794bc83ab817e65fb1a2f063/identify-1.0.7.tar.gz"
    sha256 "496d3cce9c4088664e4840e0e01db460820bffa13f03a3016078d99feda0cd74"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/9f/0e/dd1c52f02a8ed7563da1984a5a6c740d3c752d4c6bcdb5f87dabf5c0d839/nodeenv-1.2.0.tar.gz"
    sha256 "98835dab727f94a713eacc7234e3db6777a55cafb60f391485011899e5c818df"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
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
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<~EOS
        -   repo: https://github.com/pre-commit/pre-commit-hooks
            sha: v0.9.1
            hooks:
            -   id: trailing-whitespace
      EOS
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
