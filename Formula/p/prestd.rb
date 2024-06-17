class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "ea53b4f72fffde1acaac5f19e392507b36e69294ed9bd767192edcf01531fbed"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf9fb365d46a363d440305eef801c50954d8b6b21df502d8846034210ec929ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a9378447fbf913bc3ddf6d8a744194be713ae934a8dc8b3eb4f6faa225e0142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90fabecf3614c86470c7e8a30c76320723c43bc5ffab3e040864a724535f053d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f457e5d26d2d04a7024a1027b38334af31318d8838fe3f2e128cc3284f0ec70"
    sha256 cellar: :any_skip_relocation, ventura:        "d1478727908a55da7dc67f22cf7e42cdc774a85c13a2984a484d36077c7cc7b5"
    sha256 cellar: :any_skip_relocation, monterey:       "a70898f690860e743750e8b5a8cb9343d56ab63e41aac7f9b7cdc0f1a614e25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86c35956be944c4a298b5cfd7e324b4c1da2ac4e7697a3093afaf38d97c2ddd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"
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
