class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.6.tgz"
  sha256 "3d8f9a98f8b5dfe58d53fbc78ca256e18f22f600760ecd9f5b4f964fcba5b82c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e784773caf60bc93fa8c020e7c56bf7032370abeab1ead343c2c8478bda635e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e784773caf60bc93fa8c020e7c56bf7032370abeab1ead343c2c8478bda635e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e784773caf60bc93fa8c020e7c56bf7032370abeab1ead343c2c8478bda635e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a626cb4bf360098efe5318825dd5395afd267b74e16310f03174961178624319"
    sha256 cellar: :any_skip_relocation, ventura:       "a626cb4bf360098efe5318825dd5395afd267b74e16310f03174961178624319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "819eff9ea12fc1d3e72f5b3956f66104071648b3de2a084fb2eb15db698e01f0"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
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
    assert_match "2 requests processed (2 succeeded)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
