require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.27.0.tgz"
  sha256 "77010866c1e04f3c4ef09bd9076b3adb32c8585f4580acebf7599d2834be861b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a3d58777381571fbabf4c023cb13da0145f1e77e58c39b50bc90616755578d" => :catalina
    sha256 "945c71f494fcba0afecf91172181f826d4bb311256a7999b8912098d835f5e7f" => :mojave
    sha256 "51fc6cfa21ea4d2f42a93de0908f12a3fea0f3cc3dea4bc83e663c4854a9a440" => :high_sierra
  end

  depends_on "node"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/52/11/5a7b1730daa960228ba970b0b452cbeafbd6fa5c34851210be8e5c30aba9/cattrs-1.0.0.tar.gz"
    sha256 "b7ab5cf8ad127c42eefd01410c1c6e28569a45a255ea80ed968511873c433c7a"
  end

  resource "constructs" do
    url "https://files.pythonhosted.org/packages/96/4a/2f8f8b7be20a8826ba216f054d4b9ee0b30eec2b54c28663fcc3dd9a96dd/constructs-2.0.2.tar.gz"
    sha256 "5e8f23c3bb0ed154383dcc6418f97c8b2f104d0621ff2b5ffd7cfddf241b0658"
  end

  resource "jsii" do
    url "https://files.pythonhosted.org/packages/00/4d/c63b1e9a3335bb13bf146fcdc1f4e5870b351af41ffbb2b9d4701a419aab/jsii-1.10.0.tar.gz"
    sha256 "cc6b2d818c24c32d6da9139df7f520d36a3002febb36b4cd41db6d5bea0ea710"
  end

  resource "publication" do
    url "https://files.pythonhosted.org/packages/6b/8e/8c9fe7e32fdf9c386f83d59610cc819a25dadb874b5920f2d0ef7d35f46d/publication-0.0.3.tar.gz"
    sha256 "68416a0de76dddcdd2930d1c8ef853a743cc96c82416c4e4d3b5d901c6276dc4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/6a/28/d32852f2af6b5ead85d396249d5bdf450833f3a69896d76eb480d9c5e406/typing_extensions-3.7.4.2.tar.gz"
    sha256 "79ee589a3caca649a9bfd2a8de4709837400dfa00b6cc81962a1e6a1815969ae"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/cdk8s", "import", "k8s", "-l", "python"
    assert_predicate testpath/"imports/k8s", :exist?, "cdk8s import did not work"
  end
end
