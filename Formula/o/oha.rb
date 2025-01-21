class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "44ae493c24f42f8994b4192ace99e63866c054e305d368bf77176108cbfa93fd"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eac11cb3fb9c60fbffe35ae659200e4491eca44ba1d6dd9c790a1a9c20c328f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92d34d54400e6fd3b89941b53d9123ad3ccf48729f5d1be339d0bc82a866f723"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1023f87ef5f7e7d0a8822b28e0b7686ffadb4a79ffcd1530c30ed0126926c1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0c6a3ab1ef063700120ae41e4d0effb55c4c7f77874a8c3c130e6529542c702"
    sha256 cellar: :any_skip_relocation, ventura:       "33932e34c92a5cf9da0c0750b367db40fc63892c56cc045995038c7acfe427a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9ae4a5a98546c0aea7407e2626a616c9e38b84db2649a947ce882812edcea7"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  # revert `cc` crate to 1.2.7, upstream pr ref, https://github.com/hatoo/oha/pull/662
  patch do
    url "https://github.com/hatoo/oha/commit/e016c271326c201343cf17347dd5c5d6b0de1ab7.patch?full_index=1"
    sha256 "c3b9b1ef1486e0a9427b2623c8f6852c78fd7fd020383f36a5d2d62cb20b5970"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
