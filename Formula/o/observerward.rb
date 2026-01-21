class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2026.1.13.tar.gz"
  sha256 "7f15a48928617b9acd08ec189b20e9dd796830328c27f7bdea8369a5605f30de"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a512214aebb7ce2c5b30521407db42d54444ffe70138d9ef5148be6256ec6797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "321a40ced48d4388890747b981f3688e3f5a8a8d8a9d77d4f30793e3f223b3d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95774cd0f192c59984a4342241991c4030b78fbb405edc3da5f54be2b29f295e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b97113459bf0f3cfd930ce7108670b5669c425e9ae3bbcea8e203ba7bfd6ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a220e4fc24e90d8f1cc080b1cd79fc46de666a7323392cb45c0fd9c45ed54751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2996035aa9b94a3a89a82f5fc45758a3cf1cb30fea55c7a5967e6fd7c3bd3924"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
