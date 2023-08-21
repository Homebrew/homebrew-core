require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.3.tgz"
  sha256 "dc22be401cceff7554c5ff4d1697d1eb7b2244ea41e84975a74c40d668c51126"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3630a83740bab56853e6ca865390a5916354122352626c00c341462b04505ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3630a83740bab56853e6ca865390a5916354122352626c00c341462b04505ec7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3630a83740bab56853e6ca865390a5916354122352626c00c341462b04505ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "fb128647697e46448eb0760ccd1905e3d9846b5d0e7884e489b15ce382536313"
    sha256 cellar: :any_skip_relocation, monterey:       "fb128647697e46448eb0760ccd1905e3d9846b5d0e7884e489b15ce382536313"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb128647697e46448eb0760ccd1905e3d9846b5d0e7884e489b15ce382536313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217694c8d65ba352133f214bd5466ad7069d568a7d89e76a552c7c28daedbe39"
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
