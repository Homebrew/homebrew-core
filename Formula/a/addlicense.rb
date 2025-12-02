class Addlicense < Formula
  desc "Scan directories recursively to ensure source files have license headers"
  homepage "https://github.com/google/addlicense"
  url "https://github.com/google/addlicense/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d2e05668e6f3da9b119931c2fdadfa6dd19a8fc441218eb3f2aec4aa24ae3f90"
  license "Apache-2.0"
  head "https://github.com/google/addlicense.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d805d6f3d40e1004189f3ac86a50250f2a2c7eef920127565c59f646f703ed30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d805d6f3d40e1004189f3ac86a50250f2a2c7eef920127565c59f646f703ed30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d805d6f3d40e1004189f3ac86a50250f2a2c7eef920127565c59f646f703ed30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d805d6f3d40e1004189f3ac86a50250f2a2c7eef920127565c59f646f703ed30"
    sha256 cellar: :any_skip_relocation, sonoma:        "feee4e9cf952c2d3bc600e044b275c059450a897543c033c7bae0961020175fb"
    sha256 cellar: :any_skip_relocation, ventura:       "feee4e9cf952c2d3bc600e044b275c059450a897543c033c7bae0961020175fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "146bce5af0963bcfad9a958fcb92b082c1ae4c95971f09a43f7dffecbc83ca0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c37cd4c9c5b2dcb5fc8091b30900e71216d0d7fd4fe6d562d10b2d1a38fd46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.go").write("package main\\n")
    system bin/"addlicense", "-c", "Random LLC", testpath/"test.go"
    assert_match "// Copyright 2025 Random LLC", (testpath/"test.go").read
  end
end
