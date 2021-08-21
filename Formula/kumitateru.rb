# typed: false

# frozen_string_literal: true

# Kuitateru formula
class Kumitateru < Formula
  desc "Build system for Garmin ConnectIQ. Simple, fast, powerful"
  homepage "https://github.com/ggoraa/kumitateru"
  url "https://github.com/ggoraa/kumitateru/releases/download/0.4.0/kumitateru-mac"
  sha256 "a286ad0d3f729464294fa23c85cc40df04d6c8f4c28ca6015dea387f1f84362d"
  license "GPL-3.0-only"

  def install
    # ENV.deparallelize
    bin.install "kumitateru-mac" => "kumitateru"
  end

  test do
    system "true"
  end
end
