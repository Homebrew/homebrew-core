require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.29.0.tar.gz"
  sha256 "e8dafeefbdc1699ccd65566f0d353c610f9847fbfd49483c1d4e6ed154a8c273"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "691c510e0dacb3e2689f8daa34abe79f7b37d35100bebe354ccdd888cab2a406"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e192f37c90cf6fcae84119e0e356fa84435274d3bda3fee85b9d24a8f3bf1cd"
    sha256 cellar: :any_skip_relocation, catalina:      "1e192f37c90cf6fcae84119e0e356fa84435274d3bda3fee85b9d24a8f3bf1cd"
    sha256 cellar: :any_skip_relocation, mojave:        "1e192f37c90cf6fcae84119e0e356fa84435274d3bda3fee85b9d24a8f3bf1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d9b8571b3be5c4769cadc1ac5655d72be8ac0dd65bff1f8878a20162742135"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/#{name}/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    on_macos do
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
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
