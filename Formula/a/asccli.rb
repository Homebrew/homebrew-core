# typed: false
# frozen_string_literal: true

class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "37b73ccda07ddf0d81842e5ec75f6c83c025aa0f6a0b04cdf1c27fc144b54c81"
  license "MIT"

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  uses_from_macos "swift" => :build

  def install
    inreplace "Sources/ASCCommand/ASC.swift", '"0.1.0"', %Q("#{version}")
    inreplace "Sources/ASCCommand/Commands/Version/VersionCommand.swift", '"asc 0.1.0"', %Q("asc #{version}")
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/asc" => "asccli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asccli --version")
  end
end
