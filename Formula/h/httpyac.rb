require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.11.4.tgz"
  sha256 "119a580fa5bab6532797f88343403806dd178e0338b8b1500d91831efc8ce4b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d044ae4a8ffc25110668c1ef897cff5deb4a8254e71939d9d0a28e99e9bbe5ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d044ae4a8ffc25110668c1ef897cff5deb4a8254e71939d9d0a28e99e9bbe5ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d044ae4a8ffc25110668c1ef897cff5deb4a8254e71939d9d0a28e99e9bbe5ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d6b02ad2474cb2a578d6270d48f71869fdbe3d08f805205dbbf379b947757f5"
    sha256 cellar: :any_skip_relocation, ventura:        "3d6b02ad2474cb2a578d6270d48f71869fdbe3d08f805205dbbf379b947757f5"
    sha256 cellar: :any_skip_relocation, monterey:       "3d6b02ad2474cb2a578d6270d48f71869fdbe3d08f805205dbbf379b947757f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23d716e64e3274d2f7a938f734025d0c5809b6b11f216dbc8fde2fa29ad2c303"
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
