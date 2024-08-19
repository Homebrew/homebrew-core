class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.31.tar.gz"
  sha256 "c56df95f1f329460144979c57d9a30c4726a13bb7aa9f71ce21760358843a8cc"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7a9c79233bedf0d8f95f44fc86484c06fab6a4a63addf1f82e5acf8abd1ee58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f6fe6937793a627f7c247cef99ec08840ab52df0b8e437d95419d880a9ded55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f69ddccd5439ffae17faa5829717ea991ed4e8f5e010ebc9191110c5558c36a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "15088b3631940eefdfaa7e75d3c624c4a12ef8e5f3d6733dbe85d3c19819e5eb"
    sha256 cellar: :any_skip_relocation, ventura:        "bb45c96722a19d5306e7ced688a6a45f1c3a50b0cb2316cb77566f9404d84546"
    sha256 cellar: :any_skip_relocation, monterey:       "3b38b8016049ba6031ac668e73e2687093783d085c11c2fcba359c8a98f5778e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4c0fb055a2c0c31c6de0195386dfd747f6c2597ce522dd45e55b17149f0d99"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
