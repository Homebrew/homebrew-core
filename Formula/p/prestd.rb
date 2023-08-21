class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.3.1.tar.gz"
  sha256 "29717aea35e345e55e239cc714ede8c052bc190fcc47371dd91dce32197fa68c"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8114075e039588893ec1f0022c566a6de0ee5e9a56381f555eecde5fdcdb4f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb72ee5d80232d43569d788f2c8cce99a7b6fb88175ffb34e38d00fcf3e2089"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b24589f1ccbec98ea0adaf27831b26d02a84e79730e66eb8d17d42765d078a04"
    sha256 cellar: :any_skip_relocation, ventura:        "7a2bba250f55447bb5be46b8ae09c13db6e680a254df82d6127332504dc4c08c"
    sha256 cellar: :any_skip_relocation, monterey:       "845eb9fd0ecc7d4fb9f2976d2352daee6b633c2765e8be8e688e95cb0ed42e89"
    sha256 cellar: :any_skip_relocation, big_sur:        "3139bc0f0be0650799555a40209765b3d3ea3acd538a53034e3588686c18c8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367b436e1a9864ff58113b7957e3de2fd8910cf5eb7d9cfd1ffd864fa392d20e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/prestd"
  end

  test do
    (testpath/"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("#{bin}/prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
