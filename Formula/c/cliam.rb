class Cliam < Formula
  desc "Cloud agnostic IAM permissions enumerator"
  homepage "https://github.com/securisec/cliam"
  url "https://github.com/securisec/cliam/archive/refs/tags/2.2.0.tar.gz"
  sha256 "3fd407787b49645da3ac14960c751cd90acf1cfacec043c57bbf4d81be9b2d9e"
  license "GPL-3.0-or-later"
  head "https://github.com/securisec/cliam.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bdbb9e4d7e3ab70487a38e936259d6930f3cfcf8595a0d386fe31fed365f326a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "97fc79aa1d589ee7a6deff3bee41579070570cb721217851da1a327c9a9a9efb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "437320520b17ed0562c0aaa5cb931385823cdb79396d80e1a00b38502f3ef1e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "692e06fb736fd26d5e37dbe2a17c29df8903ac8ebf268ad12540dc07b1cc86c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9b5d99ab7fe62e8f523bd2db18f4353aa586cbebdec4f57b19e309039b4d6df"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a6d64eb832b3f1c9697a494a1e81a126ca99642242e5bbd9eb0b7d5f49801f4"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd86d65d9168a5cf41321b8e972326c9a5d0f387cda0829aa20e95fa55bc016"
    sha256 cellar: :any_skip_relocation, monterey:       "2ffb08eafd8af22b575ec3380b2a17e61ea6bafce22d9335c951aba4e8d9e7b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4f73cfe2097f8574bed1d44bc8fd29cd66a95e122dbb8866d17724a1ff2a7aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ab86af9ed168ceecfafde29cbc74503b4c929ab102e94492c8e423145b55d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/securisec/cliam/cli/version.BuildDate=#{time.iso8601}
      -X github.com/securisec/cliam/cli/version.GitCommit=
      -X github.com/securisec/cliam/cli/version.GitBranch=
      -X github.com/securisec/cliam/cli/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"cliam", "completion")
  end

  test do
    output = shell_output("#{bin}/cliam aws utils sts-get-caller-identity " \
                          "--profile brewtest 2>&1", 1)
    assert_match "SharedCredsLoad: failed to load shared credentials file", output

    output = shell_output("#{bin}/cliam gcp rest enumerate", 1)
    assert_match "accessapproval", output

    assert_match version.to_s, shell_output("#{bin}/cliam version")
  end
end
