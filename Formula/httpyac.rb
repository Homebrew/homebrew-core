require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.1.0.tgz"
  sha256 "6dd0e1ef8b95b5b967a9651668cf2dead6ea3c4cd814412e592f9fe9b878ac37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8df79d5a82eaac859ba53e947471b78a75fba2f404a4c164d34691a871afd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8df79d5a82eaac859ba53e947471b78a75fba2f404a4c164d34691a871afd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e8df79d5a82eaac859ba53e947471b78a75fba2f404a4c164d34691a871afd4"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0fbc142ada1dc6675748a0644ce78f97f4ca4c22189f202249b15af102d731"
    sha256 cellar: :any_skip_relocation, monterey:       "fe0fbc142ada1dc6675748a0644ce78f97f4ca4c22189f202249b15af102d731"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe0fbc142ada1dc6675748a0644ce78f97f4ca4c22189f202249b15af102d731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecb82fed9b73434130c5281eb00654f2ca5ba56cbfcfffdad637ae992cf89ce5"
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
