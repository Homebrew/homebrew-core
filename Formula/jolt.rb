class Jolt < Formula
  desc "JSON to JSON transformation library and CLI written in Java"
  homepage "https://bazaarvoice.github.io/jolt/"
  url "http://search.maven.org/remotecontent?filepath=com/bazaarvoice/jolt/jolt-cli/0.0.24/jolt-cli-0.0.24.jar"
  sha256 "5a4bf4afb8bd01154aa2bcf89bde87a1b2623ae8b6901893a4d9f1a291689bbf"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "jolt-cli-#{version}.jar"
    bin.write_jar_script libexec/"jolt-cli-#{version}.jar", "jolt", "$JAVA_OPTS"
  end

  test do
    (testpath/"input.json").write <<-EOS.undent
      {
        "rating": {
          "primary": {
            "value": 3
          },
          "quality": {
            "value": 3
          }
        }
      }
    EOS

    (testpath/"jolt_spec.json").write <<-EOS.undent
      [
        {
          "operation": "shift",
          "spec": {
            "rating": {
              "primary": {
                "value": "Rating",
                "max": "RatingRange"
              },
              "*": {
                "max":   "SecondaryRatings.&1.Range",
                "value": "SecondaryRatings.&1.Value",
                "$": "SecondaryRatings.&1.Id"
              }
            }
          }
        },
        {
          "operation": "default",
          "spec": {
            "Range": 5,
            "SecondaryRatings": {
              "*": {
                "Range": 5
              }
            }
          }
        }
      ]
    EOS

    (testpath/"expected_output.json").write <<-EOS.undent
      {
        "Range" : 5,
        "Rating" : 3,
        "SecondaryRatings" : {
          "quality" : {
            "Id" : "quality",
            "Range" : 5,
            "Value" : 3
          }
        }
      }
    EOS

    (testpath/"actual_output.json").write shell_output("#{bin}/jolt transform jolt_spec.json input.json")
    system "#{bin}/jolt", "diffy", "actual_output.json", "expected_output.json"
  end
end
