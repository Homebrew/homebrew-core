require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.29.0.tar.gz"
  sha256 "e8dafeefbdc1699ccd65566f0d353c610f9847fbfd49483c1d4e6ed154a8c273"
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

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

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
        "name": "example",
        "version": "#{version}",
        "description": "A basic apiDoc example"
      }
    EOS
    system bin/"apidoc", "-o", "out"
    api_data_json = (testpath/"out/api_data.json").read
    api_data = JSON.parse api_data_json
    assert_equal api_data.first["version"], version
  end
end
