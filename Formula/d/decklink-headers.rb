class DecklinkHeadersDownloadStrategy < CurlDownloadStrategy
  def _fetch(url:, resolved_url:, timeout:)
    download = JSON.parse(curl_output("https://www.blackmagicdesign.com/api/support/us/downloads.json").stdout)["downloads"]
                   .flat_map { |entry| entry.dig("urls", "Mac OS X") || [] }
                   .find { |entry| entry["product"] == "desktop-video-sdk" }
    download_url = "https://www.blackmagicdesign.com/api/register/us/download/#{download.fetch("downloadId")}"

    response = curl_output(
      download_url,
      "-X", "POST",
      "-H", "Content-Type: application/json;charset=UTF-8",
      # The exact values of fields don't matter, except for `hasAgreedToTerms`, `country`/`state`, `origin`
      # This is adapted from AUR.
      "--data", JSON.generate({
        "policy"           => "true",
        "hasAgreedToTerms" => "true",
        "country"          => "us",
        "firstname"        => "Homebrew",
        "lastname"         => "User",
        "email"            => "somebody@brew.sh",
        "phone"            => "202-555-0194",
        "state"            => "New York",
        "street"           => "Homebrew",
        "city"             => "Homebrew City",
        "product"          => "Desktop Video #{version} SDK",
        "origin"           => "www.blackmagicdesign.com",
      }),
      timeout:
    )

    curl_download(
      response.stdout.strip,
      to:          temporary_path,
      try_partial: @try_partial,
      timeout:,
    )
  end
end

class DecklinkHeaders < Formula
  desc "Header files of the Blackmagic Decklink SDK"
  homepage "https://www.blackmagicdesign.com"
  # This URL is not used here. We use this as the direct download requires its own signature.
  # We have to use a valid request to attain a signed URL to the final download.
  # We can't use the intermediate links either as they're all POST-only endpoints,
  # so online brew audit will fail on it.
  url "https://www.blackmagicdesign.com/desktopvideo_sdk",
      using:      DecklinkHeadersDownloadStrategy,
      user_agent: :fake
  version "16.0.0"
  sha256 "8ca1a5f4ed56a59f1a9731860c901690488705879a3d865204fb7f132bf00cf9"
  license :cannot_represent # MIT-like

  livecheck do
    url "https://www.blackmagicdesign.com/api/support/us/downloads.json"
    strategy :json do |json|
      # We get version for macOS, it is same for Linux
      json["downloads"]
        .flat_map { |download| download.dig("urls", "Mac OS X") || [] }
        .select { |download| download["product"] == "desktop-video-sdk" }
        .map { |download| "#{download["major"]}.#{download["minor"]}.#{download["releaseNum"]}" }
    end
  end

  no_autobump! because: :bumped_by_upstream

  def install
    doc.install "ReadMe.rtf"
    doc.install "End User License Agreement.pdf"
    include.install Dir["#{OS.mac? ? "Mac" : "Linux"}/include/*"]
  end

  test do
    assert_path_exists include/"DeckLinkAPI.h"
  end
end
