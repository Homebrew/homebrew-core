class Kconf < Formula
  desc "CLI for managing multiple kubeconfigs"
  homepage "https://github.com/particledecay/kconf"
  url "https://github.com/particledecay/kconf/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e7fe6750c719caf227890a31e2fd5446972ec3e1e5492180d0a387fe1c3394c0"
  license "MIT"
  head "https://github.com/particledecay/kconf.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6c87543d6c4aaedc4bb42116fe029725d36172535b401567bfbd0f5c3762e8d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c7ff80bea648574258dd8824d20fba4332346ddb89dc566b6286a674a3a730a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed57d62a2cfcb32f238460071f886311c492f9587ab87cfa3f23eb524e1ef490"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e32cdeb9dfbc9027d5dbce3599fed6d051b2d5a64519b09a766c219b4c829934"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a495204a9089651402915a598e0771df6f1e4818ff7cf37847976f06f0487289"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c3acf1e1e4b50f0768139f778540093c96566a5524c910b1aeb990ad480180f"
    sha256 cellar: :any_skip_relocation, ventura:        "3458e12b3ab15a5590da0c8967da531406be70c60c1e701bf40e60a8e42dce70"
    sha256 cellar: :any_skip_relocation, monterey:       "9c32f638d936965c04287be80f5b25b0a6252b6d87e3a1dabc23db18b57589b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "58922db06cb8ba21213152bd06fa5527900769b8fd34b691e0292b5b12e632c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116d253ca110da35e26bd037ccbec2286fb5d01fb8dfb2d1ced726cb371bc7ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/particledecay/kconf/build.Version=#{version}
      -X github.com/particledecay/kconf/build.Commit=#{tap.user}
      -X github.com/particledecay/kconf/build.Date=#{time.iso8601}"
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kconf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kconf version")

    output = shell_output("#{bin}/kconf namespace homebrew 2>&1", 1)
    expected = "you must first set a current context before setting a preferred namespace"
    assert_match expected, output
  end
end
