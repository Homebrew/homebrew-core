require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.50.0.tar.gz"
  sha256 "4705ba8a68df2b2285b008f19c7a724297640ad112d181625f791af87024926b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69d9f81dc0cf0416ae6fef93b09ccb994e57d47046dd6c21eb610daae87ca1fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "209889e11d2641e73152d2c67acae004e396ad1047c2c16ab751ba709ef460ca"
    sha256 cellar: :any_skip_relocation, catalina:      "209889e11d2641e73152d2c67acae004e396ad1047c2c16ab751ba709ef460ca"
    sha256 cellar: :any_skip_relocation, mojave:        "209889e11d2641e73152d2c67acae004e396ad1047c2c16ab751ba709ef460ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e98638e7ac48270c94b3e5bd063b83007ab8f51c8533a03c59fcd52fd21e19"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Extract native slices from universal binaries
    deuniversalize_machos
  end

  test do
    (testpath/"api.go").write <<~EOS
      /**
       * @api {get} /user/:id Request User information
       * @apiVersion #{version}
       * @apiName GetUser
       * @apiGroup User
       *
       * @apiParam {Number} id User's unique ID.
       *
       * @apiSuccess {String} firstname Firstname of the User.
       * @apiSuccess {String} lastname  Lastname of the User.
       */
    EOS
    (testpath/"apidoc.json").write <<~EOS
      {
        "name": "brew test example",
        "version": "#{version}",
        "description": "A basic apiDoc example"
      }
    EOS
    system bin/"apidoc", "-i", ".", "-o", "out"
    assert_predicate testpath/"out/assets/main.bundle.js", :exist?
  end
end
