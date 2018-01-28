require 'formula'

class HapiFhirCli < Formula
  homepage 'http://hapifhir.io/doc_cli.html'
  url 'https://github.com/jamesagnew/hapi-fhir/releases/download/v3.2.0/hapi-fhir-3.2.0-cli.tar.bz2'
  sha256 'cabe82d3b5107f7d789db2a057130ff5eec2ca5e889f8dfdaa03fae8202ee67c'

  def install
    inreplace 'hapi-fhir-cli', /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{prefix}"
    prefix.install 'hapi-fhir-cli.jar'
    bin.install 'hapi-fhir-cli'
  end

  def test
    (testpath/"TestResource.json").write <<~EOS
      {
        "resourceType": "Specimen",
        "id": "101",
        "text": {
          "fhir_comments": [
            "  text>\\n    <status value=\\"generated\\" />\\n    <div xmlns=\\"http://www.w3.org/1999/xhtml\\">[Put rendering here]</div>\\n  </text>  "
          ],
          "status": "generated",
          "div": "<div><p><b>Generated Narrative with Details</b></p><p><b>id</b>: 101</p><p><b>contained</b>: </p><p><b>identifier</b>: 23234352356</p><p><b>status</b>: available</p><p><b>type</b>: Venous blood specimen <span>(Details : {SNOMED CT code '122555007' = '122555007', given as 'Venous blood specimen'})</span></p><p><b>subject</b>: <a>Peter Patient</a></p><p><b>accessionIdentifier</b>: X352356</p><p><b>receivedTime</b>: Mar 4, 2011 2:03:00 AM</p><h3>Collections</h3><table><tr><td>-</td><td><b>Collector</b></td><td><b>Comment</b></td><td><b>Collected[x]</b></td><td><b>Quantity</b></td><td><b>Method</b></td></tr><tr><td>*</td><td><a>Practitioner/example</a></td><td>Specimen is grossly lipemic</td><td>May 30, 2011 2:15:00 AM</td><td>6 mL</td><td>Line, Venous <span>(Details : {http://hl7.org/fhir/v2/0488 code 'LNV' = 'Line, Venous)</span></td></tr></table><h3>Containers</h3><table><tr><td>-</td><td><b>Identifier</b></td><td><b>Description</b></td><td><b>Type</b></td><td><b>Capacity</b></td><td><b>SpecimenQuantity</b></td><td><b>Additive[x]</b></td></tr><tr><td>*</td><td>48736-15394-75465</td><td>Green Gel tube</td><td>Vacutainer <span>(Details )</span></td><td>10 mL</td><td>6 mL</td><td>id: hep; Lithium/Li Heparin <span>(Details : {http://hl7.org/fhir/v3/EntityCode code 'HEPL' = 'Lithium/Li Heparin)</span></td></tr></table></div>"
        },
        "contained": [
          {
            "resourceType": "Substance",
            "id": "hep",
            "code": {
              "coding": [
                {
                  "system": "http://hl7.org/fhir/v3/EntityCode",
                  "code": "HEPL"
                }
              ]
            }
          }
        ],
        "identifier": [
          {
            "fhir_comments": [
              "   a specimen identifier - e.g. assigned when the specimen was taken\\n     this is often not done   "
            ],
            "system": "http://ehr.acme.org/identifiers/collections",
            "value": "23234352356"
          }
        ],
        "status": "available",
        "_status": {
          "fhir_comments": [
            "  status is really about the specimen availability and includes the concepts available - The physical specimen is present and in good condition entered-in-error - The specimen was entered in error and therefore nullified. unavailable - There is no physical specimen because it is either lost, destroyed or consumed. unsatisfactory - The specimen cannot be used because of either a quality issue such as a broken container, contamination, or too old.  "
          ]
        },
        "type": {
          "fhir_comments": [
            "  \\n   Type is a loosely defined field because there is such a lot of variation in how it is used.\\n   The principal variation is how much information that could be represented elsewhere is also \\n   represented here. For instance, here's some possible types:\\n     lithium heparin plasma   (+ .container.additive) (e.g. SNOMED CT 446272009)\\n     transfusion bag of blood (+ container.type) \\n     Peritoneal lavage        (+ collection.bodySite)\\n   If the type includes other fields, it would be normal not to populate the other fields\\n\\n   Note that this practice is so widespread that it's pointless to try and stop it   "
          ],
          "coding": [
            {
              "system": "http://snomed.info/sct",
              "code": "122555007",
              "display": "Venous blood specimen"
            }
          ]
        },
        "subject": {
          "reference": "Patient/example",
          "display": "Peter Patient"
        },
        "accessionIdentifier": {
          "fhir_comments": [
            "   accession identifier - e.g. assigned by the labaratory when it is received.\\n     This is common, unlike specimen identifier   "
          ],
          "system": "http://lab.acme.org/specimens/2011",
          "value": "X352356"
        },
        "receivedTime": "2011-03-04T07:03:00Z",
        "collection": {
          "collector": {
            "reference": "Practitioner/example"
          },
          "comment": [
            "Specimen is grossly lipemic"
          ],
          "collectedDateTime": "2011-05-30T06:15:00Z",
          "_collectedDateTime": {
            "fhir_comments": [
              "   the time of collection is usually required. Usually a point in time, but can be a period \\n      (collectedPeriod) if it's a timed collection (e.g. a 24 hour urine)   "
            ]
          },
          "quantity": {
            "fhir_comments": [
              "   e.g. full   "
            ],
            "value": 6,
            "unit": "mL"
          },
          "method": {
            "fhir_comments": [
              "   method is usually implied by type   "
            ],
            "coding": [
              {
                "system": "http://hl7.org/fhir/v2/0488",
                "code": "LNV"
              }
            ]
          }
        },
        "container": [
          {
            "identifier": [
              {
                "fhir_comments": [
                  "   \\n      the container identifier is not the same as the specimen identifier\\n      usually, it is pre-printed/implanted etc.on the container prior to \\n      use. It might a RFID in the container, or it might be a UDI \\n      (http://www.fda.gov/MedicalDevices/DeviceRegulationandGuidance/UniqueDeviceIdentification/) \\n      "
                ],
                "value": "48736-15394-75465",
                "_value": {
                  "fhir_comments": [
                    "   this is a serial number off the tube - there's no context such as a system   "
                  ]
                }
              }
            ],
            "description": "Green Gel tube",
            "type": {
              "text": "Vacutainer",
              "_text": {
                "fhir_comments": [
                  "   again, this might easily be used to cover additives and capacity as well   "
                ]
              }
            },
            "capacity": {
              "value": 10,
              "unit": "mL"
            },
            "specimenQuantity": {
              "fhir_comments": [
                "   if there's only one container, then this value is the same \\n     as .collection.quantity (usually). This is for when there is more\\n     than one container   "
              ],
              "value": 6,
              "unit": "mL"
            },
            "additiveReference": {
              "reference": "#hep"
            }
          }
        ]
      }
    EOS
    system bin/"hapi-fhir-cli", "validate", "-n", testpath/"TestResource.json"
  end
end
