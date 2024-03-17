require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.12.0.tgz"
  sha256 "f3858f02826a76eb8f084a3c019f7203a8f2f1bc146f618ed8b6e7950c3829d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34a78edef6361dd61fc89766010aa0da171ef88acbd11cbb499d01a2c03ac7dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34a78edef6361dd61fc89766010aa0da171ef88acbd11cbb499d01a2c03ac7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34a78edef6361dd61fc89766010aa0da171ef88acbd11cbb499d01a2c03ac7dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e79181db386f3ea3acc306bc8dc6d4979f62b644f5e695b603e5ec1b5f5c84af"
    sha256 cellar: :any_skip_relocation, ventura:        "e79181db386f3ea3acc306bc8dc6d4979f62b644f5e695b603e5ec1b5f5c84af"
    sha256 cellar: :any_skip_relocation, monterey:       "e79181db386f3ea3acc306bc8dc6d4979f62b644f5e695b603e5ec1b5f5c84af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "340d98cc9ca0e7a1bb594b16516678c559a2fe30f90e6993a86d2b12cecb9217"
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
