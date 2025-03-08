class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.16.6.tgz"
  sha256 "8efe0c579eeef5769f92a5d17aebb4e6f4a4c57abcb2790cbe75c951e54c640a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661e132d1dd9381162c95201e98b3ba77325278f451600ef2795c7b430557f6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "661e132d1dd9381162c95201e98b3ba77325278f451600ef2795c7b430557f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "661e132d1dd9381162c95201e98b3ba77325278f451600ef2795c7b430557f6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "62fb374293c41a84675d74f38013343a9acff10197e244c2654b8c299292c946"
    sha256 cellar: :any_skip_relocation, ventura:       "62fb374293c41a84675d74f38013343a9acff10197e244c2654b8c299292c946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661e132d1dd9381162c95201e98b3ba77325278f451600ef2795c7b430557f6d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
