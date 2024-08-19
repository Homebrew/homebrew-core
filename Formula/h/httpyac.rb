class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.15.0.tgz"
  sha256 "5462d5b293e8dc52bcd58d4df1819f19c48201b8b2dec475cf08f642d34980db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cbbb2f831efff05548f4b1e0728a2e645a62adade24e4d22f9cdb6cc0c73b17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cbbb2f831efff05548f4b1e0728a2e645a62adade24e4d22f9cdb6cc0c73b17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cbbb2f831efff05548f4b1e0728a2e645a62adade24e4d22f9cdb6cc0c73b17"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c3f58d05b9f5fa63fe7530c44d8134c4cff69cb2148f50ade2e03e31dd7a59a"
    sha256 cellar: :any_skip_relocation, ventura:        "0c3f58d05b9f5fa63fe7530c44d8134c4cff69cb2148f50ade2e03e31dd7a59a"
    sha256 cellar: :any_skip_relocation, monterey:       "0c3f58d05b9f5fa63fe7530c44d8134c4cff69cb2148f50ade2e03e31dd7a59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfe83e384363005c7b0d16eafbe5b91f25c5fcd5f3cf634544b69af6288af3e8"
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
    assert_match "2 requests processed (2 succeeded))", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
