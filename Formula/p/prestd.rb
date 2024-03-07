class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "324996ee8ea430fdd005297b8f8c961da628d93c6ea2c2768f13f98b7c2e512d"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a0a86fc59a828730c148d45fc5cc94548e7b673c33c84ee612596dd33222eed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03f74a8b6548924de63ab3e04f0b1b29be1ad2e8f711e1c75c1488b12df5c995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c68fed315e9cb78213ec2401dd0c602d72153a535e66ed91549203063db51b"
    sha256 cellar: :any_skip_relocation, sonoma:         "be45cd6366878325ab56ab2a8103eb5573fb1ec569caa47b0fe9642a1a62158f"
    sha256 cellar: :any_skip_relocation, ventura:        "a15a8e4a89a1c64e17c832e5176702382e8a2ea4cf61715dcff4f5d2086ab1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "af1a682d9e0f0ee07c893bd61306cbd0ce1e3a812bdc707dd7c43ea3cae7bacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0ba8b70812607fdde8872a907aff0fc2a8cf2ee5d0e16610af759c092eb77e1"
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
