# frozen_string_literal: true

class Botfile < Formula
  desc "Symlink farm for AI agent skills and instructions"
  homepage "https://github.com/listfold/botfile"
  url "https://github.com/listfold/botfile/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "02ce903caefffc262e9c75ca372af63d7eef1a4cf75dcf0dda3f17912f0844e4"
  license "Apache-2.0"

  head "https://github.com/listfold/botfile.git", branch: "main"

  livecheck do
    url "https://github.com/listfold/botfile/releases"
    regex(/v(\d+(?:\.\d+)+)/i)
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/botfile"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/botfile version")
    assert_match "botfile", shell_output("#{bin}/botfile guide")
    assert_match(/failed/, shell_output("#{bin}/botfile plan", 2))
  end
end
