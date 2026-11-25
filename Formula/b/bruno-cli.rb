class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-4.4.0.tgz"
  sha256 "1ea90e2a2a3843a58f2f02dd1a6172d8e605959af5829509e9ad3f76aff1abc3"
  license "MIT"

  bottle do
    manifest_sha256 "b17f8924a689cb96f38973b54ba870e589e93f18f0d162ddc365c94bfa9b6343"
    sha256 cellar: :any_skip_relocation, all: "8f4eb4553fc02c546b5da7e41bf4641f08dcef33f6c2aad485e5b2366c86f7d4"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bru --version", nil, 0)
    assert_match "You can run only at the root of a collection", pipe_output("#{bin}/bru run 2>&1", nil, 4)
  end
end
