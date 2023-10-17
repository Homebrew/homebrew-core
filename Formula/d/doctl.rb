class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.100.0.tar.gz"
  sha256 "ecfbcdb576271e79834ae28fe0cd7bcb29307f68f179de247af1a68015a755cd"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf0a1e3a226e6573b490b3723f22f07e9b2291b6bf3761a51a3d051c044a2bd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f96ac6cd5ec0e7ab8ec5cd8fd708ed1091c2cc3cf503ddad08b4214741be9412"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af28d325f2a0f5e8ef83c01ee8f81ab7487236bdaddc942e9cbd9af9ef51560c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeb1264e04f8b5bef5a6f9c86a28c230ffa3b4e93ea23a94c1151ab9a21c28e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "af80d8b712ac7e181ebacaea7a5b263b5cb5eb90f4f4551558396a7756503ea2"
    sha256 cellar: :any_skip_relocation, ventura:        "2a9725de2e31b18d1033d401dbf190244e9d8003ad186507b9baa9c7c4b3b5dc"
    sha256 cellar: :any_skip_relocation, monterey:       "87ed8355183f1c7dd90382adc7f258a8440c73e567a72526e5976fe5a4e83e31"
    sha256 cellar: :any_skip_relocation, big_sur:        "af595e975228d590bd0c21c11a89ef86edab6044175555cec770e8c372f567d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b22cdcef43f8becc946e8944d243bf0ecad6967edcd31d7870b00e0272f14a4"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
