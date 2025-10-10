class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4b32289c20dfad7bf8ab653c200954b3b9981fcbf101b699ceb575c6e7661a90"
  license "Apache-2.0"
  head "https://github.com/square/certstrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cf87aa3c176fdb86b78366aa5214e745017886c8d6607699953cbdc9dae54f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d9bf9827e91f136d8e5b85211375f3130beabfd11963c8a7f6145f8870856816"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c49235a2ea7bfbf33766c4434aa3ad53321d02387bff504f963317f3f8c9797f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d6395c92d4c7e13c3f56b8d9e6a640583fa3644321093850cb106af2e91877"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd72ace92ab23822ee98e6e0a374132f17b24ed473029266918891a4c6eea074"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10cf4c0c8f42e97dac415a9ec0e34f8948a2c94602498e0125efc71ae038a553"
    sha256 cellar: :any_skip_relocation, sonoma:         "66b6eb6258724c6fecf57cb0dbcd037f9949a8e3fae020d04c0ce4d67b2b9b23"
    sha256 cellar: :any_skip_relocation, ventura:        "9c310c91576bc1115ed87292c77f1eeb073d9d29551ddc0a035a10c184a5507d"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a6dd11e17cddf336dcbf0a89da75c5e0d96eeae71bd96377ecdc353bbd6d65"
    sha256 cellar: :any_skip_relocation, big_sur:        "d97b07034dafd41e77947288ec901c169c2afbe12e302e30a188f55a5f6050b0"
    sha256 cellar: :any_skip_relocation, catalina:       "bc00650c04cae6f16bf49b6fe7f22db094fe8c948b39a1cf3ae1bebeaf4ba8a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe8dd3c67c30b994bca7946bbb6b94f90ba70d0fe2df2c71032332ae2d9cf608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87ccd6d8769ae051ec3c65a3072f704be545747acdd3c0f31a6326c1467ed50a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
