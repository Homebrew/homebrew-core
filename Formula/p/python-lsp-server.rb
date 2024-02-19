class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/6c/9f/4a3a6cc6e982eca3dfad39fdcaf48dcdc5a020f38dfe973e4487765e0048/python-lsp-server-1.10.0.tar.gz"
  sha256 "0c9a52dcc16cd0562404d529d50a03372db1ea6fb8dfcc3792b3265441c814f4"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49d62920b38a1fa8632afbc3915776bafb6859b346675b113e6de7958888d2ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f34a35430a228edc3ef19bd516fd7859f585786a6e8466931e518284ce70f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77666a826eda12ff932ba91d5e5127c079ea89d2d8b962737866f2392c7c4e90"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f69e6301e3e3fc4861a333bbd43f2ec1de8417c3317759d5541bf1a9e683ddc"
    sha256 cellar: :any_skip_relocation, ventura:        "6c3c030ce450321e12e96142eb698cfad01de3ed2838fe45987ec2098776fa00"
    sha256 cellar: :any_skip_relocation, monterey:       "5a3c2957f363a534d2b0655521fbcc1b7d4011f1cf5791d3e8e72aa074de06df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80f241be4aeb3e6888cd07ac7a54cc548aaaa9d6c32758ab03ab3111c537fe5"
  end

  depends_on "black"
  depends_on "mypy"
  depends_on "python@3.12"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/2b/11/4be3230b6ebaeb31b2406876367243780d10a28da3a881a45a960ed4469b/docstring-to-markdown-0.13.tar.gz"
    sha256 "3025c428638ececae920d6d26054546a20335af3504a145327e657e7ad7ce1ce"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/65/4a/c9a61e98a8f766c989546a02b6b96d2059e2504db9f96dec495c5834b8e7/lsprotocol-2024.0.0a1.tar.gz"
    sha256 "d0a181c6c8888cfd148ecb451425fae65fd69675ff18345da8b835780fb4918c"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/76/98/41e7fe44f2e9773bbf711ecc73c34a29b645ea6e454b36e723595d4ad4a4/pylsp-mypy-0.6.8.tar.gz"
    sha256 "3f8307ca07d7e253e50e38c5fe31c371ceace0bc33d31c3429fa035d6d41bd5f"
  end

  resource "pylsp-rope" do
    url "https://files.pythonhosted.org/packages/fe/25/1935fc44a596427d50be237658a8fd23302a7904705422a5f1e39468e921/pylsp-rope-0.1.11.tar.gz"
    sha256 "48aadf993dafa5e8fca1108b4a5431314cf80bc78cffdd56400ead9c407553be"
  end

  resource "python-lsp-black" do
    url "https://files.pythonhosted.org/packages/c0/48/06edc947f711fb076b564ee97bbecb5ae877816ccc0edf4347f57cd9d6b9/python-lsp-black-2.0.0.tar.gz"
    sha256 "8286d2d310c566844b3c116b824ada6fccfa6ba228b1a09a0526b74c04e0805f"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/48/b6/fd92e2ea4635d88966bb42c20198df1a981340f07843b5e3c6694ba3557b/python-lsp-jsonrpc-1.1.2.tar.gz"
    sha256 "4688e453eef55cd952bff762c705cedefa12055c0aec17a06f595bcc002cc912"
  end

  resource "python-lsp-ruff" do
    url "https://files.pythonhosted.org/packages/94/78/296a431800664008dedc46554090fe13e82554fa4ab708c51e8ba0e42db4/python-lsp-ruff-2.0.2.tar.gz"
    sha256 "b4a6219119d73d9175ffd88aeacb0db6859ae72f606158fdcc550e105957c8e0"

    # this depends on `ruff` solely to install the binary,
    # but we can just depend on the `ruff` formula in Homebrew
    patch :DATA
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/18/dc/abf70d2c2bcac20e8c71a7cdf6d44e4ddba4edf65acb179248d554d743db/pytoolconfig-1.3.1.tar.gz"
    sha256 "51e6bd1a6f108238ae6aab6a65e5eed5e75d456be1c2bf29b04e5c1e7d7adbae"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/4c/c5/606e9b76ce5f0fe1b66db493b13e4dc6a9d495570d30fc8ea76d275693d9/rope-1.12.0.tar.gz"
    sha256 "93a1bb991fbf0426e8d415102d1c092ccc42e826ce9a42c4d61ce53d7786d9d9"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/54/6f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619e/ujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[black mypy].map do |package_name|
      package = Formula[package_name].opt_libexec
      package/site_packages
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/pylsp -v 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)

    expected_plugins = %w[
      black
      pylsp_mypy
      pylsp_rope
      ruff
    ]
    expected_plugins.each do |plugin_name|
      assert_match("Loaded pylsp plugin #{plugin_name}", output)
    end
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index cfdf720..d84c1b7 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -13,7 +13,6 @@ readme = "README.md"
 requires-python = ">=3.7"
 license = {text = "MIT"}
 dependencies = [
-  "ruff>=0.1.5, <0.2.0",
   "python-lsp-server",
	 "cattrs!=23.2.1",
   "lsprotocol>=2022.0.0a1",
