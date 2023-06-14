require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.5.0.tgz"
  sha256 "8549974893f7504dce399159c773e3b34cac85e6007b5b4d232fc4cbbe30b6c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "813ccc2806bbf23c34d4f8072abf064829934bb2d3db3fe52e349d5b568efb3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "813ccc2806bbf23c34d4f8072abf064829934bb2d3db3fe52e349d5b568efb3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "813ccc2806bbf23c34d4f8072abf064829934bb2d3db3fe52e349d5b568efb3e"
    sha256 cellar: :any_skip_relocation, ventura:        "51da9721cf9c9c14a0e13c10b527faf0a9cee863246ed892356c0256b8b7ffff"
    sha256 cellar: :any_skip_relocation, monterey:       "51da9721cf9c9c14a0e13c10b527faf0a9cee863246ed892356c0256b8b7ffff"
    sha256 cellar: :any_skip_relocation, big_sur:        "51da9721cf9c9c14a0e13c10b527faf0a9cee863246ed892356c0256b8b7ffff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44d92e1e908fc8c3151ed02692303a152ee9516273dc97163dd61049554c45de"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"test_cases").write <<~EOS
      GET https://httpbin.org/anything HTTP/1.1
      Content-Type: text/html
      Authorization: Bearer token

      POST https://countries.trevorblades.com/graphql
      Content-Type: application/json

      query Continents($code: String!) {
          continents(filter: {code: {eq: $code}}) {
            code
            name
          }
      }

      {
          "code": "EU"
      }
    EOS

    output = shell_output("#{bin}/httpyac send test_cases --all")
    # for httpbin call
    assert_match "HTTP/1.1 200  - OK", output
    # for graphql call
    assert_match "\"name\": \"Europe\"", output
    assert_match "2 requests processed (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
