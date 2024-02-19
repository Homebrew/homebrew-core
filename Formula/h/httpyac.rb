require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.11.3.tgz"
  sha256 "702c56a666a822ed1dfd6f5bf206e7927c07b3d5f0f00a255b3b07578975a41a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49ad1167711b245c10592050024cf42dd6a7ad15c9e8da1c9eeac7658a3f504a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49ad1167711b245c10592050024cf42dd6a7ad15c9e8da1c9eeac7658a3f504a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ad1167711b245c10592050024cf42dd6a7ad15c9e8da1c9eeac7658a3f504a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c05f3a7b25a2ad09f1d1edc95c158cd6e888a2ca89e467848829f4734c91cddd"
    sha256 cellar: :any_skip_relocation, ventura:        "c05f3a7b25a2ad09f1d1edc95c158cd6e888a2ca89e467848829f4734c91cddd"
    sha256 cellar: :any_skip_relocation, monterey:       "c05f3a7b25a2ad09f1d1edc95c158cd6e888a2ca89e467848829f4734c91cddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941f7d7f0da8fd0b9fddb64e5d01f530a2463044348740a243692258d9ec8f95"
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
