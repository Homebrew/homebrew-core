require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.12.2.tgz"
  sha256 "3011787f658d738d976c2cc2205188828e12aa3964f58fa3e1254f5d86381b04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bb820bec09c614d7d5cf687ab1cf0b7ddf3d0f694e528ff44496955bc6326a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb820bec09c614d7d5cf687ab1cf0b7ddf3d0f694e528ff44496955bc6326a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb820bec09c614d7d5cf687ab1cf0b7ddf3d0f694e528ff44496955bc6326a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "92a873ea80a39f7b8c6c5165ff0ee6b4892e0c8daf8698e5480a5d0b64852d43"
    sha256 cellar: :any_skip_relocation, ventura:        "92a873ea80a39f7b8c6c5165ff0ee6b4892e0c8daf8698e5480a5d0b64852d43"
    sha256 cellar: :any_skip_relocation, monterey:       "92a873ea80a39f7b8c6c5165ff0ee6b4892e0c8daf8698e5480a5d0b64852d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7cc59c57e409562dae6d833c1e38556e6c1f97971ea8ec2209c9831181ea93c"
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
