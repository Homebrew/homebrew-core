class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "ec832b1d9403ac2057a943a0c614949e64d9147512cc0527531427997d54d596"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4ccf5da28183c53f079e5b90e0ddf244cfd6809688c6a022625c513f2984637"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4888c9ebedd37c38b72f88c564413f02704d7488f49d825dbf3fb30b7637940"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cbe799cdd9f5b59c2d24dc5596ae70489008aa8365d3a42e7902bf88d3bc6ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1e7aa8e1f30b83a80127eec9760c1acd9c36c46a8a16fa29e113079e5e65e05"
    sha256 cellar: :any_skip_relocation, ventura:        "193a2040bd28de02e4be2b5fc59b1f9c0f0b9f9bb9d0951590b0112b6eaabab2"
    sha256 cellar: :any_skip_relocation, monterey:       "694f9993dbf06fe2fb26207b7100fa9f3713135ce470402941a524f4c036ffe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b92b189b41397cd1a5b73ad4a8d7f61705bb4e20208f629f502e3fa9309c7e31"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
