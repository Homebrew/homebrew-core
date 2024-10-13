class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.15.1.tgz"
  sha256 "11b27e1932565254774d202f761ff48d65cad9647f9a97054d71fc612e91a499"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8dc2ec6a22109082d4f5e5a93e19edc376041bbc0ad8473d974ca1242bc5ec98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb21ddc576c6306588668db649ae3fd195f2f9028ec5a4ba54003df0f77b6762"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb21ddc576c6306588668db649ae3fd195f2f9028ec5a4ba54003df0f77b6762"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb21ddc576c6306588668db649ae3fd195f2f9028ec5a4ba54003df0f77b6762"
    sha256 cellar: :any_skip_relocation, sonoma:         "13312cc839a990bc7296085da59b1f9a07455b6657594d44b7d2cfb44bd4b69a"
    sha256 cellar: :any_skip_relocation, ventura:        "13312cc839a990bc7296085da59b1f9a07455b6657594d44b7d2cfb44bd4b69a"
    sha256 cellar: :any_skip_relocation, monterey:       "13312cc839a990bc7296085da59b1f9a07455b6657594d44b7d2cfb44bd4b69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2ee39c71c690daf9dd46f4e58c75bee6e2067578528bc212b2f5653b39fe73e"
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
    assert_match "2 requests processed (2 succeeded)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
